Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933510Ab2FHFc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:32:56 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35726 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933254Ab2FHFcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:32:54 -0400
MIME-Version: 1.0
In-Reply-To: <CANQmPXjbmqzckXgzX+HsXxM6_HS1etdGEUbauZyPKwLf_WtNPg@mail.gmail.com>
References: <CANQmPXjbmqzckXgzX+HsXxM6_HS1etdGEUbauZyPKwLf_WtNPg@mail.gmail.com>
Date: Fri, 8 Jun 2012 13:32:54 +0800
Message-ID: <CANQmPXiqUHSHXLGDABK=Ey=PbRnwoU4rEihfEVr4Q0NERJsazw@mail.gmail.com>
Subject: Re: [ANNOUNCE][PATCH 06/06]RIFS v4 release. All the complex idea is gone.
From: Chen <hi3766691@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benchmark(RIFS-Foreground tuning on sysctl):
idle load:

Using 2991769 loops per ms, running every load for 30 seconds
Benchmarking kernel 3.3.5-RIFS-V3 at datestamp 201206081304

--- Benchmarking simulated cpu of Audio in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
None	   0.0 +/- 0.0        0.0		 100	        100
Video	   0.0 +/- 0.0        0.0		 100	        100
X	   0.0 +/- 0.0        0.0		 100	        100
Burn	   0.0 +/- 0.0        0.0		 100	        100
Write	   0.0 +/- 0.0        0.0		 100	        100
Read	   0.0 +/- 0.0        0.0		 100	        100


latt -c180 sleep 300 load:

Using 2991769 loops per ms, running every load for 30 seconds
Benchmarking kernel 3.3.5-RIFS-V3 at datestamp 201206081309

--- Benchmarking simulated cpu of Audio in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
None	   0.0 +/- 0.0        0.0		 100	        100
Video	   0.0 +/- 0.0        0.0		 100	        100
X	   0.0 +/- 0.0        0.1		 100	        100
Burn	   0.0 +/- 0.0        0.0		 100	        100
Write	   0.0 +/- 0.0        0.0		 100	        100
Read	   0.0 +/- 0.0        0.4		 100	        100


Benchmark(CFS):
idle load:

Using 2991769 loops per ms, running every load for 30 seconds
Benchmarking kernel 3.3.7-1.fc16.i686.PAE at datestamp 201206071923

--- Benchmarking simulated cpu of Audio in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
None	   0.0 +/- 0.1        1.5		 100	        100
Video	   0.0 +/- 0.0        0.0		 100	        100
X	   0.0 +/- 0.1        3.6		 100	        100
Burn	   0.0 +/- 0.0        0.6		 100	        100
Write	   0.0 +/- 0.0        0.2		 100	        100
Read	   0.0 +/- 0.0        0.8		 100	        100

latt -c180 sleep 300 load:

Using 2991769 loops per ms, running every load for 30 seconds
Benchmarking kernel 3.3.7-1.fc16.i686.PAE at datestamp 201206071933

--- Benchmarking simulated cpu of Audio in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
None	   0.0 +/- 0.3        6.6		 100	        100
Video	   0.0 +/- 0.1        1.7		 100	        100
X	   0.5 +/- 1.1        5.1		 100	        100
Burn	   0.0 +/- 0.1        0.8		 100	        100
Write	   0.0 +/- 0.2        3.1		 100	        100
Read	   0.0 +/- 0.2        4.5		 100	        100
