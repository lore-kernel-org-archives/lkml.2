Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab1AaWgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 17:36:41 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63326 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab1AaWgk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 17:36:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=tTS/WCwb8VAEEQB2TdK7X0waWem5A+cJyiiQxWYw+VUQaO8DwYrxHjex7dW3fBohV5
         tWu9VAp5J2l9ATbz1IVx807jkTjS1SW8WT9haF+85v+UKIGjRH9k2dX1skfAjfptff+p
         eZ9ed9Xuohe4LrkVw32Zk/2k1rTS28tN8D7i4=
MIME-Version: 1.0
In-Reply-To: <AANLkTikfO_uKa16eQJZgSHL6CjTassCmv7W_VcPDON9u@mail.gmail.com>
References: <AANLkTikfO_uKa16eQJZgSHL6CjTassCmv7W_VcPDON9u@mail.gmail.com>
From: Manish Katiyar <mkatiyar@gmail.com>
Date: Mon, 31 Jan 2011 14:36:19 -0800
Message-ID: <AANLkTikL_+_STupmVyD6pLKrTETmGQ=v0MMMWW=nq-UO@mail.gmail.com>
Subject: Re: process exception
To: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
Cc: Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 2:31 PM, Sri Ram Vemulpali
<sri.ram.gmu06@gmail.com> wrote:
> Hi all,
>
>  This is regarding segment fault. Is there any feature that we can
> allow kernel to kill only the thread that generate seg fault rather
> than killing whole process in which it is running. Why is that we did
> not implement in such way. Is there any specific reason. Thanks in
> advance for explanation.

What is the guarantee that whole process isn't hosed up ? For example
let's say a global pointer became NULL and we died accessing it from 1
of the threads. I'm not sure if it would be better to have 'N'
coredumps as opposed to just 1.


-- 
Thanks -
Manish
