Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759598Ab0HEA2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 20:28:05 -0400
Received: from web27008.mail.ukl.yahoo.com ([217.146.177.8]:28719 "HELO
	web27008.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754007Ab0HEA16 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 20:27:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=eq59vJAQEyoar1G6WeDrGqLQnY47pOJRR3ia162UnczXAqYj1XHBvVrat+txyjvyCMaO2y4Xpj22N3NUrN6EeYg8JY0LVV3vvV6sznaLVr+lCLk10tHnYWi6o5GLwR+rX0jgZ+tOCuPQBF98piJMKEk6oH0tkBHGM4TAjcTLX7o=;
Message-ID: <999475.75291.qm@web27008.mail.ukl.yahoo.com>
X-YMail-OSG: dE7mSdAVM1lHoc8Dj2WAwlaQrujnFn7OdS1JZ7CBipPhfJd
 IRR0PknR1SFaS3sxQdOIIKLug0CFvbEyYqnNHPWyZtukVmGWq4f9tPnamTOY
 LI_kDAopGWqOSAala90qhyiTTIWOHXzA64UXf068476VmT8iSVH00kUAulq_
 OlyAJKyIXfA8qpZFuTHMX7XfuwXXOoeSc925CCA.42ABtIe8lp8lCNhjBAsK
 7tyhlwAYPLQ50iUfa069igCfpLnF48gCR1FNtFcUoWyeEQqOFPzhpOO3P7xH
 qm.tT_mWXG3nsqwYqFRno
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Thu, 5 Aug 2010 00:27:56 +0000 (GMT)
From: bifferos <bifferos@yahoo.co.uk>
Subject: Re: [tip:x86/cpu] x86, cpu: RDC doesn't have CPUID, which is what c_ident is
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        florian@openwrt.org, mark@bifferos.com, tglx@linutronix.de,
        Ingo Molnar <mingo@elte.hu>, linux-tip-commits@vger.kernel.org
In-Reply-To: <4C59F343.20901@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- On Thu, 5/8/10, H. Peter Anvin <hpa@linux.intel.com> wrote:
> > Without the patch RDC is misreported as Cyrix
> Cx486SLC.
> > 
> 
> And what problems does that cause?  Presumably none,

If I don't know the CPU how do I set the tick rate?

http://android.git.kernel.org/?p=kernel/common.git;a=commitdiff_plain;h=e1b4d1143651fb3838be1117785b6e0386fa151f




      
