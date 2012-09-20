Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab2ITL6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 07:58:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59417 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab2ITL6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 07:58:43 -0400
Date: Thu, 20 Sep 2012 12:58:34 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 02/25] userns: Convert gadgetfs to use kuid and kgid
 where appropriate
Message-ID: <20120920115834.GA3523@kroah.com>
References: <877grox6ql.fsf@xmission.com>
 <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
 <1348141326-23355-2-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348141326-23355-2-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 04:41:43AM -0700, Eric W. Biederman wrote:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Felipe Balbi <balbi@ti.com>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
