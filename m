Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934008Ab0J2PB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 11:01:57 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:50420 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932818Ab0J2PBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 11:01:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19658.57791.952367.70027@quad.stoffel.home>
Date: Fri, 29 Oct 2010 11:01:19 -0400
From: "John Stoffel" <john@stoffel.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        agruen@suse.de, tvrtko.ursulin@sophos.com
Subject: Re: [PATCH 03/20] fanotify: implement fanotify listener ordering
In-Reply-To: <20101028213151.24810.60039.stgit@paris.rdu.redhat.com>
References: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
	<20101028213151.24810.60039.stgit@paris.rdu.redhat.com>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Eric" == Eric Paris <eparis@redhat.com> writes:

Eric> The fanotify listeners needs to be able to specify what types of
Eric> operations they are going to perform so they can be ordered
Eric> appropriately between other listeners doing other types of
Eric> operations.  They need this to be able to make sure that things
Eric> like hierarchichal storage managers will get access to inodes
Eric> before processes which need the data.  This patch defines 3
Eric> possible uses which groups must indicate in the fanotify_init()
Eric> flags.

Eric> FAN_CLASS_PRE_CONTENT
Eric> FAN_CLASS_CONTENT
Eric> FAN_CLASS_NOTIF

Reviewed-By: john@stoffel.org
