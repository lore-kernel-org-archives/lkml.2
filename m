Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab1ARPvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 10:51:55 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59258 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab1ARPvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 10:51:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=N8Qh0dI6s0LYISjTtuXrF/xm9FG1ltexbpa8szeF5iwrSWEW6NYte6kitNX0qMJUFY
         ry2aAIBIivdqe+85zMCxbbMTCcUIaJqDbvhsQq0p0PHq1c8rChvXnD9Uhb0A+o3HN/rF
         A0XB283NCQSctTzomF/b3gt2absjL+oIxduk8=
Date: Tue, 18 Jan 2011 23:52:12 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Anithra P Janakiraman <anithra@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/0] Panic on softdog timeout
Message-ID: <20110118155212.GB17710@hack>
References: <4D358B34.7040902@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D358B34.7040902@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 06:14:36PM +0530, Anithra P Janakiraman wrote:
>
>Hi.
>
>We currently have no way of determining the reason for failure when a
>softdog timeout occurs. At the minimum a snapshot of the system would
>help to determine the cause.
>The attached patch invokes panic on softdog timeout iff kdump is
>configured, if kdump is not configured it works as usual.
>

We don't do it in this way, check softlockup_panic, we have
a boot parameter, i.e. "softlockup_panic=". :)
