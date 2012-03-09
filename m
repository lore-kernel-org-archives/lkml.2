Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252Ab2CIVST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 16:18:19 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60606 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757615Ab2CIVSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 16:18:18 -0500
Date: Sat, 10 Mar 2012 01:18:13 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mtk.manpages@gmail.com, akpm@linux-foundation.org, xemul@parallels.com,
        linux-man@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 2/2] Add kcmp.2 manpage
Message-ID: <20120309211813.GO13346@moon>
References: <1331326042-32558-1-git-send-email-gorcunov@openvz.org>
 <1331326042-32558-3-git-send-email-gorcunov@openvz.org>
 <4F5A6D09.3050704@zytor.com>
 <20120309210342.GN13346@moon>
 <4F5A72E9.5030802@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5A72E9.5030802@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 01:15:21PM -0800, H. Peter Anvin wrote:
> No, you missed the point, which is that the comma moved to the .IR line.
> 
> .BR and .IR mean "alternate between bold/italic and regular", so
> 
> .IR foo bar
> 
> gives you "foobar" where only "foo" is italiziced.  It is equivalent to:
> 
> \fIfoo\fPbar
> 

Ouch, sorry. Will update shortly.

	Cyrill
