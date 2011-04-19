Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab1DSGJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 02:09:04 -0400
Received: from science.horizon.com ([71.41.210.146]:55757 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751979Ab1DSGJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 02:09:02 -0400
Date: 19 Apr 2011 02:09:01 -0400
Message-ID: <20110419060901.1738.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: luto@mit.edu
Subject: Re: [RFT] Please test rdtsc on various x86-64 hardware (app included)
Cc: linux-kernel@vger.kernel.org, linux@horizon.com
In-Reply-To: <20110419050618.18187.qmail@science.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bit more info on those failing tests (common headers snipped):

$ ./evil-clock-test -v -v -v
CPU vendor   : AuthenticAMD
CPU model    : AMD Phenom(tm) 9850 Quad-Core Processor
CPU stepping : 3
TSC flags    : tsc rdtscp constant_tsc nonstop_tsc
Using mfence_rdtsc because you don't have an Intel CPU
Will test the "mfence;rdtsc" clock.
Running now test...
Now test passed  : margin 168 with 15176312 samples
Running load3 test...
Load3 test got no data
Running load test...
  Failed 5/615154 times with worst error 4
  Failed 3/618034 times with worst error 4
  Failed 4/618552 times with worst error 7
  Failed 2/618457 times with worst error 7
  Failed 1/618518 times with worst error 4
  Failed 2/616455 times with worst error 4
  Failed 1/617990 times with worst error 4
Load test failed : worst error 7 with 4323160 samples
Running store test...
  Failed 3/614883 times with worst error 4
  Failed 3/616023 times with worst error 4
  Failed 6/613633 times with worst error 4
Store test failed: worst error 4 with 1844539 samples

Running now test...
Now test passed  : margin 168 with 15125496 samples
Running load3 test...
Load3 test got no data
Running load test...
  Failed 5/603344 times with worst error 4
  Failed 3/609628 times with worst error 4
Load test failed : worst error 4 with 1212972 samples
Running store test...
  Failed 2/610838 times with worst error 3
  Failed 4/611400 times with worst error 4
Store test failed: worst error 4 with 1222238 samples

Running now test...
Now test passed  : margin 169 with 15136216 samples
Running load3 test...
Load3 test got no data
Running load test...
Load test got no data
Running store test...
  Failed 1/617293 times with worst error 4
Store test failed: worst error 4 with 617293 samples

Running now test...
Now test passed  : margin 170 with 15128832 samples
Running load3 test...
Load3 test got no data
Running load test...
Load test got no data
Running store test...
Store test got no data

Running now test...
Now test passed  : margin 170 with 15039712 samples
Running load3 test...
Load3 test got no data
Running load test...
  Failed 4/617259 times with worst error 4
  Failed 4/621375 times with worst error 4
Load test failed : worst error 4 with 1238634 samples
Running store test...
Store test got no data

Now test passed  : margin 169 with 14977856 samples
Running load3 test...
Load3 test got no data
Running load test...
  Passed with margin 2 (613724 samples)
  Failed 7/610443 times with worst error 30
Load test failed : worst error 30 with 1224167 samples
Running store test...
Store test got no data

Running now test...
Now test passed  : margin 170 with 15131920 samples
Running load3 test...
Load3 test got no data
Running load test...
  Failed 3/607735 times with worst error 4
  Failed 4/614570 times with worst error 4
  Failed 1/614801 times with worst error 4
  Failed 5/614483 times with worst error 4
  Failed 4/614106 times with worst error 4
  Failed 1/614649 times with worst error 4
  Failed 5/614351 times with worst error 8
  Failed 4/614453 times with worst error 4
  Failed 4/614643 times with worst error 4
Load test failed : worst error 8 with 5523791 samples
Running store test...
  Failed 5/613788 times with worst error 4
  Failed 1/614285 times with worst error 4
Store test failed: worst error 4 with 1228073 samples

