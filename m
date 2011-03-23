Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799Ab1CWMiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 08:38:15 -0400
Received: from linux-sh.org ([111.68.239.195]:58300 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932767Ab1CWMiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 08:38:14 -0400
Date: Wed, 23 Mar 2011 21:37:45 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dev@uclinux.org, David Howells <dhowells@redhat.com>,
        Greg Ungerer <gerg@uclinux.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NOMMU: support SMP dynamic percpu_alloc
Message-ID: <20110323123745.GA30292@linux-sh.org>
References: <1300826506-23192-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300826506-23192-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 04:41:46PM -0400, Mike Frysinger wrote:
> From: Graf Yang <graf.yang@analog.com>
> 
> The percpu code requires more functions to be implemented in the mm core
> which nommu currently does not provide.  So add inline implementations
> since these are largely meaningless on nommu systems.
> 
> Signed-off-by: Graf Yang <graf.yang@analog.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Looks ok to me. I've got a couple other fixes I'm working on at the
moment, so I'll roll this in to my nommu tree and send it along.
