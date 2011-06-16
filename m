Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab1FPLmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 07:42:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55907 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756488Ab1FPLmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 07:42:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=M+aRTxkkNOkF6GZUOm1gI1iC1VTXCgqtJuIxBqXOEFK90BqVGdw/4AWHMguQRhf5OV
         H1NFEou3b4DWwkHKtB5i5de2pg7A78CTpxezGMcILb/wik/58YCoybjkiK8wB9dBNjkt
         2i8ZLrRl3LsPF8w9k9zvo87Yvsee51OST7TcA=
Message-ID: <4DF9EC15.6050101@gmail.com>
Date: Thu, 16 Jun 2011 14:42:13 +0300
From: Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        zohar@linux.vnet.ibm.com
Subject: Re: [RFC v1 1/5] crypto: GnuPG based MPI lib
References: <cover.1307522457.git.dmitry.kasatkin@intel.com> <de6d48b4ace4f23545aa220f4a06bb189ae703e9.1307522457.git.dmitry.kasatkin@intel.com> <alpine.LRH.2.00.1106160936590.8929@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.1106160936590.8929@tundra.namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/06/11 02:38, James Morris wrote:
> On Wed, 8 Jun 2011, Dmitry Kasatkin wrote:
> 
>> From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
>>
>> Adds the multi-precision-integer maths library which was originally taken
>> from GnuPG and ported to the kernel by (among others) David Howells.
>> This version is taken from Fedora kernel 2.6.32-71.14.1.el6.
> 
> FYI, any future postings should be cc'd to the linux-crypto list.
> 

Of course.. I missed it.

