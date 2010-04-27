Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab0D0LkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 07:40:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:35564 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab0D0LkG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 07:40:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=veGVIxEP2bqQ2lYiS7SfiNcIraWGVtLRxEyigWytm2qr5M4wfA51gCWJm1rjcLmPIe
         Eyf2Dr6l2kBInpsuKlk0bvmLs1fIJzmWcbxv452H+37xZ1aXOQC8djUYrtNnvnSVJuoP
         TjatYNEhVeGN2NJ31zCsTFTuuEeF2JsHTvOaU=
MIME-Version: 1.0
In-Reply-To: <20100427113639.GU5724@kvack.org>
References: <20100427063547.GL5724@kvack.org> <71097.1272365836@localhost>
	 <u2k84144f021004270431ke981e355i6e82688bfe3842aa@mail.gmail.com>
	 <20100427113639.GU5724@kvack.org>
Date: Tue, 27 Apr 2010 14:40:04 +0300
X-Google-Sender-Auth: 2b626eb5d984d53b
Message-ID: <p2y84144f021004270440nbd3b61d7tac630cd2d9a496b8@mail.gmail.com>
Subject: Re: I am an emotional amoeba who loves Erika-with-a-k and 
	Erika-with-a-k loves me.
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Benjamin LaHaise <bcrl@lhnet.ca>
Cc: Valdis.Kletnieks@vt.edu, Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Tue, Apr 27, 2010 at 02:31:50PM +0300, Pekka Enberg wrote:
>> I care but there's not much I can do unless he posts the complete oops
>> and his .config.

On Tue, Apr 27, 2010 at 2:36 PM, Benjamin LaHaise <bcrl@lhnet.ca> wrote:
> This happened on Brain v2.0 released February 7th, 1998.  The only relevant
> config option was CONFIG_MALE=y.  The backtrace will be coming out in blog
> form at some time in the near future, but I had to store it in my verbal
> memory for lack of a serial console.  If anyone has any hints on how to
> install netconsole on current Brain modules, I'd greatly appreciate a
> detailed HOWTO on the subject.

Can you reproduce the problem with CONFIG_ERIKA disabled?
