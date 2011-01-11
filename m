Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254Ab1AKOn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 09:43:57 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:26189 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932179Ab1AKOn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 09:43:56 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 1BqYoP0VM1lNwFy5W8a.Pz6gLP5MengE9hNXETBpHsfg0da
 3UFFwROPG_LYClReQlec8ezRFWlKH_Z3V1nLXRbXScC03rUjbyliT4AYzhFX
 3APdb7pEtNaxyz.jWcHTsrlKij7L3B5OrQfFti0ff8LkoAvWedXvafm0GwNC
 DW4YQt9cCqeXuVONWZPulakFpNvLbftpZshCpS0grjx3qzcrIKxTDLUroAOh
 eD7mT6VKpptTIWpPDAC_Mb8j3yLLOaDF.GHr_S6AzRjRR3UGWyI5AV9c.k7w
 geA9KOKpLTdatN2xPCc5n3LSJTA0AhbSZP80.yrvRU1Mkqf1UPRM-
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 11 Jan 2011 08:43:51 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: BUG: sleeping function called from invalid context at
 mm/slub.c:793
In-Reply-To: <AANLkTim4VM7GjGonXwTs9zwuaOTzegbNKHLpN1QEE1th@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1101110843360.8657@router.home>
References: <20110110105433.GA17881@shutemov.name> <alpine.DEB.2.00.1101101051260.12243@router.home> <20110110193117.GA20027@shutemov.name> <4D2C279D.5050309@redhat.com> <4D2C3115.9030301@redhat.com> <20110111111345.GA23544@shutemov.name>
 <AANLkTim4VM7GjGonXwTs9zwuaOTzegbNKHLpN1QEE1th@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Reviewed-by: Christoph Lameter <cl@linux.com>

