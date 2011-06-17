Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425Ab1FQP6Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 11:58:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64449 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab1FQP6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 11:58:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GZMWp76o+mG4hS5dueWKRBVV6XU2WkdWizy0JeKyTSo2BZPZ7I9qCW7vxNeqFZyODM
         MV1Lk/zGyiUEmr9NP4uRkMYT786UdkkAM3S1dLoJuscusDtK8t0ab+wM2dTbDfLYWBi7
         PUHQ03u6p/jBXcwbtK4S76Dp+/Cp0x6wCE4QY=
Date: Fri, 17 Jun 2011 19:58:15 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        apparmor@lists.ubuntu.com,
        "selinux@tycho.nsa.gov Stephen Smalley" <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
        John Johansen <john.johansen@canonical.com>,
        kernel-hardening@lists.openwall.com
Subject: Re: [RFC v1] security: introduce ptrace_task_access_check()
Message-ID: <20110617155815.GA22756@albatros>
References: <20110617152912.GA21885@albatros>
 <4DFB7605.9000909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFB7605.9000909@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 11:43 -0400, Eric Paris wrote:
> No need to rename the function

The rename would cause renames in procfs, kernel/ptrace.c and similar
places.

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
