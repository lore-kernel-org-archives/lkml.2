Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab1EJUMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 16:12:52 -0400
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:38779 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab1EJUMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 16:12:50 -0400
X-Greylist: delayed 565 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 May 2011 16:12:50 EDT
Subject: [ANNOUNCE] IPTV-Analyzer project released v0.9.0
From: Jesper Dangaard Brouer <hawk@comx.dk>
To: hawk@comx.dk
Content-Type: text/plain; charset="UTF-8"
Organization: ComX Networks A/S
Date: Tue, 10 May 2011 16:03:19 -0400
Message-ID: <1305057799.2688.8.camel@probook>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm happy to announce the first official release of the IPTV-Analyzer
project, as an Open Source project.

 Homepage:
  http://www.iptv-analyzer.org

 Git tree:
  https://github.com/netoptimizer/IPTV-Analyzer

The IPTV-Analyzer is a continuous/real-time tool for analyzing the
contents of MPEG2 Transport Stream (TS) packets, which is commonly
used for IPTV multicast signals. The main purpose is continuous
quality measurement, with a focus on detecting MPEG2 TS/CC packet
drops.

The core component is an iptables (Linux) kernel module, named
"mpeg2ts".  This kernel module performs the real-time Deep Packet
Inspection of the MPEG2-TS packets. Its highly performance optimized,
written for parallel processing across CPU cores (via RCU locking) and
hash tables are used for handling large number of streams. Statistics
are exported via the proc filesystem (scalability is achieved via use
of the seq_file proc API).  It scales to hundreds of IPTV channels,
even on small ATOM based CPUs.

Please send bugreports, patches, improvement, comments or insults to:
 hawk@comx.dk

-- 
Best regards,
  Jesper Dangaard Brouer
  ComX Networks A/S
  Linux Network Kernel Developer
  Cand. Scient Datalog / MSc.CS
  Author of http://adsl-optimizer.dk
  LinkedIn: http://www.linkedin.com/in/brouer

