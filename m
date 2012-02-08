Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab2BHOq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 09:46:29 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:30398 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753487Ab2BHOq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 09:46:28 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: r.f9vSUVM1n.rTdkTZJamvgbowc.iPxMjkvloO1p6kzDDwI
 .r2Zoltxvw3bYuvZEXwcuEHOSyai6zQ1hMX38c3hohTx6I.XwJCT0Mab7_jj
 BOobIZa0D6N7MPiIm4NAcaDMx_U7nplpZ7.VbsTObqURiGtGckeLxOrBUIZO
 GgKSNK13U2H5MDHfeKtMTCuRXHxs8WBDyZRJcMnqfKlg8NGCxGISNdLfCvea
 FyF_nAYxAt8S0YcFeVLDmHvLrpBEhEI3R8o83c3weVqnJ33UDuxqdE0em9xv
 Kxr2XRW3Nr8Od8yK4SwRsfYPBrRmsz8bBx7CJe8hoC4ekdypV7rRZd_mpPMU
 UOrcSkBkmQlLrpae_tZmgf0MS4gNQ1LTAr9Q9umYSmLC.HmaGRMNXaY54RZd
 f.b00
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 8 Feb 2012 08:46:26 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "Alex,Shi" <alex.shi@intel.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [rfc PATCH]slub: per cpu partial statistics change
In-Reply-To: <1328676290.12669.431.camel@debian>
Message-ID: <alpine.DEB.2.00.1202080846030.29839@router.home>
References: <1328256695.12669.24.camel@debian>  <alpine.DEB.2.00.1202030920060.2420@router.home>  <4F2C824E.8080501@intel.com>  <alpine.DEB.2.00.1202060858510.393@router.home>  <1328591165.12669.168.camel@debian>  <alpine.DEB.2.00.1202070910320.29500@router.home>
 <1328676290.12669.431.camel@debian>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Feb 2012, Alex,Shi wrote:

> > A bit long I think. CPU_PARTIAL_DRAIN?
>
> Yes. it is more meaningful. :)
> Patch change here.

Acked-by: Christoph Lameter <cl@linux.com>
