Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab1AUSqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 13:46:37 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:38198 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753917Ab1AUSqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 13:46:36 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: zjxCWGEVM1mYPoBPSvpPqzq5Dh29Hw9zzIl3_oCgQGAy66e
 LE.M3n5rJICpRpZyz2PiOxqtW.PH2jba8UeZAtP_dGV.MXCD4wuGOqZCoWP5
 6ngmRfVMuMVvDCRrIJm1CbF3nQ870Qqv4MDASv9HQi9B3LdVra4A5UegUzlK
 oyySzS_Dt.4GYreB5g2dpablcezjkIRk3g1Z6a_fnIKphWOhsilFemVIoE34
 hWqPuOZuk.Dsyvj4FpKZXevJxrDajn1H8Fo.k
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 21 Jan 2011 12:46:32 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [cpuops cmpxchg double V2 1/4] Generic support for
 this_cpu_cmpxchg_double
In-Reply-To: <8110a580-58bd-4dab-881c-7e69bf75ad96@email.android.com>
Message-ID: <alpine.DEB.2.00.1101211244450.15692@router.home>
References: <alpine.DEB.2.00.1101071227450.3014@router.home> <20110108172453.GF13269@mtj.dyndns.org> <4D393636.4040607@cs.helsinki.fi> <20110121092649.GA2832@htj.dyndns.org> <4D39A6EB.70705@zytor.com> <20110121154831.GE2832@htj.dyndns.org> <20110121165425.GB11687@Krystal>
 <20110121170847.GH2832@htj.dyndns.org> <1da7491b-6e7d-4453-9c6f-0e7767421ec4@email.android.com> <alpine.DEB.2.00.1101211121350.15692@router.home> <20110121174236.GA12150@Krystal> <8110a580-58bd-4dab-881c-7e69bf75ad96@email.android.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011, H. Peter Anvin wrote:

> What is the problem with passing 128-bit structures by value?  I'm quite sure *that* is okay.

You mentioned that earlier and I tried to pass 128 bit structures. My
compiler did not do any of that (gcc 4.4.5). Could come up with
some example code to make yourself certain?


