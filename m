Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab0FAGXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 02:23:43 -0400
Received: from crca.org.au ([74.207.252.120]:39445 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669Ab0FAGXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 02:23:41 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C04A767.8000209@crca.org.au>
Date: Tue, 01 Jun 2010 16:23:35 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, airlied@gmail.com
Subject: 2.6.35 Radeon KMS power management regression?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.

Just wondering if anyone else has tried to hibernate while using Radeon 
KMS and a tree with Dave's post 2.6.34 patches? My 32 bit P4 based 
system (with an RV250 card) is hanging at the atomic copy, with the 
following backtrace

hibernation_snapshot
dpm_suspend_start
async_synchronize_full
async_synchronize_cookie
async_synchronize_cookie_domain

I've been trying to bisect, but this computer is being painfully slow, 
so I haven't been making much progress. 2.6.34 with the same config is 
fine, and my bisection progress so far seems to be pointing at the merge 
I mentioned above.

Nigel
