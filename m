Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab0FPF14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 01:27:56 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45476 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab0FPF1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 01:27:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=K7F3gsS37+wdFGpLZ0m4Fm9iwnWeUbbo77ji+prqKM8ysOhsBr05rXM2SdfliEhnJk
         JUjCZonxKEhiDWiErT1FNBGgVd2uwTlTA4J+OmFBq8J/FP8qhwfjnRgTdgUGrAMZYMPu
         old0Y0vRo18MdWAUDuLPQBIKw8Hk6QHBajLKw=
MIME-Version: 1.0
In-Reply-To: <4C1809D3.7030707@panasas.com>
References: <AANLkTikziSEDW07YiiJs6ny6JLhSQ-TGvdw_kTroIIx5@mail.gmail.com>
	<4C1809D3.7030707@panasas.com>
Date: Wed, 16 Jun 2010 13:27:54 +0800
Message-ID: <AANLkTikYn_EwizmUq6ZxitJ6ibCkr8Nfd4yslK_Bo0zR@mail.gmail.com>
Subject: Re: [uml-devel] [PATCH] um: Include missing header file in 
	os-linux/mem.c
From: Liu Aleaxander <aleaxander@gmail.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 7:16 AM, Boaz Harrosh <bharrosh@panasas.com> wrote:
> On 06/15/2010 04:06 AM, Liu Aleaxander wrote:
>> The os-linux/mem.c file calls fchmod function, which is declared in sys/stat.h
>> header file, so include it.
>>
>
> Yes. I have the same patch.
>
> Apparently it's new for Fedora 13. Previous Fedora's are compiling fine.

Same here:)

> I guess something has changed with the new gcc headers include sequence



-- 
Thanks & regards
Liu Aleaxander
