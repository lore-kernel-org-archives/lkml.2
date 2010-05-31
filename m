Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab0EaKCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 06:02:22 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:51493 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab0EaKCU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 06:02:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wOUmGnDRFDdDfv5tmn1wsuQPR+qyPRQmlPUmnByNEpra+QfkSTwRzUIHJqmByHs5IQ
         QPG/ocADBHNKMGDLuyrZsdGw5hg+OOhvAefHXn9/VtNK6d3bYFmGz0BbT8G6ZF61HxUl
         DttRiMAKgxBIyHqKbFtScALAKPJeTsArZzQGE=
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1005311017530.24571@tundra.namei.org>
References: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
	<alpine.LRH.2.00.1005311017530.24571@tundra.namei.org>
Date: Mon, 31 May 2010 15:02:19 +0500
Message-ID: <AANLkTil8LHjRT_PMosymmtBb1pxIzkBaWC0ef35DCBUU@mail.gmail.com>
Subject: Re: [PATCH 00/14] EVM
From: Shaz <shazalive@gmail.com>
To: James Morris <jmorris@namei.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       securityengineeringresearchgroup 
	<securityengineeringresearchgroup@googlegroups.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 5:20 AM, James Morris <jmorris@namei.org> wrote:
> On Wed, 21 Apr 2010, Mimi Zohar wrote:
>
>> Much appreciation to Dave Hansen, Serge Hallyn, and Matt Helsley for
>> reviewing the patches.
>
> We're not seeing much comment on this code beyond the folk above.  It
> might help to cc fsdevel.
>
> Also, I raised some issues:
>
>  I'd also be interested to know what kind of user demand there is for EVM
>  -- are there any specific instances of user requirements which are met
>  by it?  Do any distros plan to enable and support it?
>
> and does this code meet the requirements of potential users such as Meego ?

EVM is based on EA while Aegis does not use EA as far as I can
understand from the documentation available. Can we make EVM
independent of EA? Even the MAC mechanism is very different then
existing LSM based mechanisms.



-- 
Shaz
