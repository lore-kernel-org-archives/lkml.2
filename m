Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab1BBUQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 15:16:43 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39454 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab1BBUQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 15:16:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nD/LJZkxABd0LOVgNdZQ7065FkDkB7LSZ5vMdx5JaZh2NYWUJg8xT+AvtmDdqb+Bxf
         XMcWtcy2sDmFoquwSObKk9DkA3HO29Sq6yqQ5wHkPhj0Jfr6Q5hcGbiyy3ZCZjDXjeWS
         0eiNs6HufG6rbhmifqyr13zm8+12fPg8Xf05E=
MIME-Version: 1.0
In-Reply-To: <20110202201023.GC28705@opensource.wolfsonmicro.com>
References: <alpine.DEB.2.00.1102021504550.31867@ayla.of.borg>
	<20110202144924.GD9810@sirena.org.uk>
	<AANLkTindwELkXft9phmiaduyB5icMCbAorbKxZMYP2bw@mail.gmail.com>
	<20110202201023.GC28705@opensource.wolfsonmicro.com>
Date: Wed, 2 Feb 2011 15:16:41 -0500
Message-ID: <AANLkTi=RZoqS1D3qQXJNupbBOcWLHdWiCNWmiVvvKV++@mail.gmail.com>
Subject: Re: Build regressions/improvements in v2.6.38-rc3
From: Arnaud Lacombe <lacombar@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Feb 2, 2011 at 3:10 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Feb 02, 2011 at 03:06:53PM -0500, Arnaud Lacombe wrote:
>
>> if CONFIG_BUG has been set to "n", it _will_ return. It could have
>> been made to trigger a crash, but it did not, on purpose.
>
> Oh no, not another one :(
>
Care to explain ?

 - Arnaud
