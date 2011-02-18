Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab1BRB0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 20:26:34 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:30737 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754641Ab1BRB0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 20:26:33 -0500
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'Grant Likely'" <grant.likely@secretlab.ca>
Cc: <linux-kernel@vger.kernel.org>, "'Ewe, Kok Howg'" <kok.howg.ewe@intel.com>,
        "'Lai, Mee Sim'" <mee.sim.lai@intel.com>,
        "'Toshiharu Okada'" <toshiharu-linux@dsn.okisemi.com>
References: <F5323EE7947C4C1CB0868F843FB4F917@hacdom.okisemi.com> <AANLkTim4z7vfyNceLYZhGzpYaECeSfLOYjzEhT9JFvJH@mail.gmail.com>
Subject: RE: About GPIO interrupt function with sysfs
Date: Fri, 18 Feb 2011 10:26:30 +0900
Message-ID: <706C311929004CBBA1D60DA8BE622471@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Thread-Index: AcvPBM8B3yxMotRjTs+zCREt+zhMmQABUPFQ
In-Reply-To: <AANLkTim4z7vfyNceLYZhGzpYaECeSfLOYjzEhT9JFvJH@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Thank you for your information.
It seems use "edge" file,
using poll/select usermode application can detect the interrupt.

Thanks,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.


> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Grant Likely
> Sent: Friday, February 18, 2011 9:43 AM
> To: Tomoya MORINAGA
> Cc: linux-kernel@vger.kernel.org; Ewe, Kok Howg; Lai, Mee 
> Sim; Toshiharu Okada
> Subject: Re: About GPIO interrupt function with sysfs
> 
> On Thu, Feb 17, 2011 at 5:34 PM, Tomoya MORINAGA 
> <morinaga526@dsn.okisemi.com> wrote:
> > Hi,
> >
> > I have a question.
> > Can our GPIO driver (pch_gpio) have interrupt function?
> 
> yes.
> 
> g.
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in the body of a message to 
> majordomo@vger.kernel.org More majordomo info at  
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

