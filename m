Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab0CXQ4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:56:40 -0400
Received: from web94907.mail.in2.yahoo.com ([203.104.17.160]:38303 "HELO
	web94907.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932138Ab0CXQ4i convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:56:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=PcCoIyRizhYcfyRIdhgRBMl9xR68csY4F+zDqvgX19Ze7k4I1cO2uwRlnx2yLH/gQs/79zji6oP8PUb5377usH0Hc7LV7XA5Hk7LhlzkV6lRp3j7XUvpaVB6CVl+TTnERwpKIsmXveYYcqDubL+uSGDzMs+DCPILlwtqKjZbrF8=;
Message-ID: <491848.26863.qm@web94907.mail.in2.yahoo.com>
X-YMail-OSG: 9uvhnNoVM1nkAyMM_6YJB5eryUuWvA8YrAyYGlnyjtpIrye
 GcKSf04MeqZ.t4kcZ.0JYs_Rvc4JCWeR27TTvLESze.KcBH2sdhV9OLAzbce
 8Skh0HqpXlEdFbb.PK9lcLZ7EgDw_NXcw_IXybSz9Zg6NBWQGCpvLo8_PwVt
 vUD75i9ZnJip9UUbf_4UqaGOZt8h2hWpOnaAfpdSwaLEj71KeozDlWzIxE16
 XxCtqgxxwfn9sOZ2dSphuGx9FEDoXQFfBXhMpk8v2ZkfpXdDhTZa.InLhapg
 68CL26ffFgR_OMctv4P0W1aQ-
X-Mailer: YahooMailClassic/10.0.8 YahooMailWebService/0.8.100.260964
Date: Wed, 24 Mar 2010 22:26:35 +0530 (IST)
From: Pavan Savoy <pavan_savoy@yahoo.co.in>
Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Marcel Holtmann <marcel@holtmann.org>, Greg KH <gregkh@suse.de>,
       PavanSavoy <pavan_savoy@ti.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100324165800.722086c3@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Wed, 24/3/10, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
> To: "Pavan Savoy" <pavan_savoy@yahoo.co.in>
> Cc: "Marcel Holtmann" <marcel@holtmann.org>, "Greg KH" <gregkh@suse.de>, "PavanSavoy" <pavan_savoy@ti.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
> Date: Wednesday, 24 March, 2010, 10:28 PM
> > The core of the problem is we
> cannot ask/install/ldisc_put for a line discipline from
> kernel space.
> 
> The device is always in WL protocol mode and starts this
> way ?

Totally makes sense, just EXPORT the symbol tty_set_ldisc or tiocsetd, so that kernel space drivers can install/un-install LDISC.

> 
> If so lets simply fix the tty layer to allow a driver to
> set the initial
> ldisc.
> 
> > The only reason I wanted this to be in staging was to
> have sort of continuous review process, and in hope the
> driver wouldn't be forgotten.
> 
> I would certainly prefer this as it is much easier to
> refine this way
> 
> Alan
> 


      Your Mail works best with the New Yahoo Optimized IE8. Get it NOW! http://downloads.yahoo.com/in/internetexplorer/
