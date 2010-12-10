Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab0LJPqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 10:46:19 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:64592 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab0LJPqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 10:46:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tPuY6PsobQMgoS5H72QybL4zY/7zf+qYFCpuwmngjfqGJ2chKT64wGm0eszmU8yjIh
         4YvjvhyBh4uZPG9r1lPGjb1Us3ivrtLKsnZi+V2skI0zro9x1oXcjq/p1siCq9Q9J7xb
         6ZXqQJcUTeehFz4Gdtz/n0n3XZMPYFUuzu8Ig=
MIME-Version: 1.0
In-Reply-To: <1291953342-4905-2-git-send-email-fernando.lugo@ti.com>
References: <1291953342-4905-1-git-send-email-fernando.lugo@ti.com>
	<1291953342-4905-2-git-send-email-fernando.lugo@ti.com>
Date: Fri, 10 Dec 2010 17:46:16 +0200
Message-ID: <AANLkTikoW3N3NUqXnJcZrSMEjKPT4O8aEF6irjvToopW@mail.gmail.com>
Subject: Re: [PATCHv2 1/4] staging: tidspbridge - use GTP7 for DSP stack dump
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Fernando Guzman Lugo <fernando.lugo@ti.com>
Cc: omar.ramirez@ti.com, linux-kernel@vger.kernel.org, nm@ti.com,
        ohad@wizery.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 5:55 AM, Fernando Guzman Lugo
<fernando.lugo@ti.com> wrote:
> DSP stack dump is changed to GTP7 due to GPT8 is used
> by DSP side apps

Does this require a special baseimage firmware? Or all firmwares can use GPT7?

-- 
Felipe Contreras
