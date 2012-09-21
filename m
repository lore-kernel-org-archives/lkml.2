Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab2IUGor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 02:44:47 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:36011 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab2IUGoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 02:44:46 -0400
Date: Fri, 21 Sep 2012 07:44:42 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Subject: Re: [PATCH 09/14] userns: Convert binder ipc to use kuids
Message-ID: <20120921064442.GB15718@kroah.com>
References: <87k3vote43.fsf@xmission.com>
 <1348187330-6616-1-git-send-email-ebiederm@xmission.com>
 <1348187330-6616-9-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1348187330-6616-9-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 05:28:45PM -0700, Eric W. Biederman wrote:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Cc: Arve Hjønnevåg <arve@android.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
