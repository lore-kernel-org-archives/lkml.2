Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab0HYLxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 07:53:10 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47613 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245Ab0HYLxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 07:53:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=MFNw5AfABXVFWUMM5gyqL+iwgpI7nk2NZTG93QOrG+AtK+I0XfoJnmSVCdbVc3dvZv
         V42bjkq5kGNIBuqFnKdMJ+Dugi81xCunWGaoadLGFoUirS2GSDaeMKOaxtFgevS7HVyo
         idw61fK7gxr9NkgCgiAf0Nkk8hEjv8PSvAiuQ=
MIME-Version: 1.0
In-Reply-To: <20100824104046.a8018469.randy.dunlap@oracle.com>
References: <AANLkTinzaRBaWX9EJTAt70Qk+bifFicUUGh=vRJaWL+N@mail.gmail.com>
 <AANLkTikQXxmzC1LxOC7wUWj40nRyLvBgGa0NO3_2s5oX@mail.gmail.com> <20100824104046.a8018469.randy.dunlap@oracle.com>
From: Richard Hartmann <richih.mailinglist@gmail.com>
Date: Wed, 25 Aug 2010 13:52:47 +0200
Message-ID: <AANLkTinPLxZxOW70FtJBA3f4eG8kc-ju-G=UoATKV0qk@mail.gmail.com>
Subject: Re: System silently not booting with 2.6.35 nor with 2.6.35.3 -- It
 works fine with 2.6.32.x and 2.6.18.x
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, kernelnewbies@nl.linux.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 19:40, Randy Dunlap <randy.dunlap@oracle.com> wrote:

> I would try enabling CONFIG_DEVTMPFS and CONFIG_DEVTMPFS_MOUNT.

As neiter the working nor the broken config has this option enabled, I
don't know
how this will help with finding the combinations of config options that made the
kernel fail to boot. Unless I am missing something?


Thanks,
Richard
