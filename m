Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab0DOBPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 21:15:23 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54161 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab0DOBPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 21:15:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=UGEgmrrXa6dEWTthUWoMWNDar8tgcSR+DOPO7cIJNrWXh7WtNQWnABQsmnOmO9WPjy
         Dy5rCp0VP6pYCN5K1n+SXhvhSwsMJdeZZhU5tyk0Xh7b8oQGb4//PwUrqEdfrwb6wbFh
         vhPDmjCnwNF/JRzqGd7kzYo7En6qN+uZGLojk=
MIME-Version: 1.0
In-Reply-To: <CEE6BB42CAD6E947908279175AF8470A03A50F78@EXDCVYMBSTM006.EQ1STM.local>
References: <1270681920-4461-1-git-send-email-linus.walleij@stericsson.com>
	 <v2se9c3a7c21004071645u8180f4d7p3b4b1f96de11303e@mail.gmail.com>
	 <CEE6BB42CAD6E947908279175AF8470A03A50F78@EXDCVYMBSTM006.EQ1STM.local>
Date: Wed, 14 Apr 2010 18:15:21 -0700
X-Google-Sender-Auth: 9b26d39fb590a3fb
Message-ID: <t2qe9c3a7c21004141815x70ecf123p4364802681417da9@mail.gmail.com>
Subject: Re: [PATCH 00/11] ARM: PrimeCell DMA Interface v5
From: Dan Williams <dan.j.williams@intel.com>
To: Linus WALLEIJ <linus.walleij@stericsson.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Grant Likely <grant.likely@secretlab.ca>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, Apr 7, 2010 at 11:35 PM, Linus WALLEIJ
<linus.walleij@stericsson.com> wrote:
> If it's OK with Russell, putting 04-06 plus 09 through async_tx
> tree is a good starter.

Getting closer... I have pushed out the dma40 driver (v3), 4, and 6.
The other patch in -mm I could take as well but that needs an ack from
Russell.

5 is pending the review comment and 9 does not apply cleanly (does it
depend on something in the spi tree?)

--
Dan
