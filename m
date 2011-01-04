Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751110Ab1ADK3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 05:29:22 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:36340 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab1ADK3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 05:29:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CsXJSl2Nl/lKBMy2v0R1DFg32Q2e1snN/YXNKKHOUPwCG1R231+QJa5u+Ic9Y0VBVq
         25cMktC8QaUvU3tKq6mZ9h7c+0JDaTZWNbGORbhTGD6Zu8fSBnGXf++TdqIZVJ7yZyM9
         cSjWqkGeO7Z98hADemwsqlvIVrsjr45W0ONFA=
Date: Tue, 4 Jan 2011 18:29:09 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-team@lists.ubuntu.com
Subject: Re: Kernel build
Message-ID: <20110104102909.GA5600@cr0.nay.redhat.com>
References: <AANLkTins3HdRJ-Y7bCuXFjOhjx+-nxDHSqUxBPuuxFxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTins3HdRJ-Y7bCuXFjOhjx+-nxDHSqUxBPuuxFxg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 09:59:29AM +0200, Anca Emanuel wrote:
>Question: Why I need to rebuild all the modules, if they are already builded.
>https://wiki.ubuntu.com/KernelTeam/GitKernelBuild
>If I make an one line change, I need to wait one hour to make an new
>kernel on an intel core duo at 2GHz sistem ?

Depends on which file you change, if that is a header file,
it is supposed to re-compile all the C source files that include it.

Thanks.
