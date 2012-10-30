Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964793Ab2J3Oz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 10:55:27 -0400
Received: from mta-out.inet.fi ([195.156.147.13]:54829 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932633Ab2J3OzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 10:55:25 -0400
Message-ID: <508FEA5A.7010406@cc.hut.fi>
Date: Tue, 30 Oct 2012 16:55:22 +0200
From: =?ISO-8859-1?Q?Lasse_K=E4rkk=E4inen?= <ljkarkk2@cc.hut.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: urandom is too slow
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apparently there has been little or no development on urandom even 
though the device is in widespread use for disk shredding and such use. 
The device emits data at rather slow rate of 19 MB/s even on modern 
hardware where other software-based PRNGs could do far better. An even 
better option seems to be utilizing AES for encrypting zeroes, using a 
random key, allowing for rates up to 500 MB/s with hardware that has 
AES-NI instructions.

Why is urandom so slow and why isn't AES hardware acceleration utilized?

