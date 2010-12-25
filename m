Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab0LYEy6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 23:54:58 -0500
Received: from eagle.jhcloos.com ([207.210.242.212]:47197 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab0LYEy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 23:54:56 -0500
X-Greylist: delayed 477 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Dec 2010 23:54:56 EST
From: James Cloos <cloos@jhcloos.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Dave Jones <davej@redhat.com>, Youquan Song <youquan.song@intel.com>,
        cpufreq@vger.kernel.org, venki@google.com, arjan@linux.intel.com,
        lenb@kernel.org, suresh.b.siddha@intel.com, kent.liu@intel.com,
        chaohong.guo@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH 0/6] cpufreq: Add sampling window to enhance ondemand governor power efficiency
In-Reply-To: <20101223205148.GB6441@comet.dominikbrodowski.net> (Dominik
	Brodowski's message of "Thu, 23 Dec 2010 21:51:48 +0100")
References: <1293085424-18212-1-git-send-email-youquan.song@intel.com>
	<20101223110020.GC18363@comet.dominikbrodowski.net>
	<20101223173402.GA3821@redhat.com>
	<20101223205148.GB6441@comet.dominikbrodowski.net>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0.50 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2009 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Fri, 24 Dec 2010 23:24:48 -0500
Message-ID: <m3zkrueaxj.fsf@jhcloos.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Hashcash: 1:30:101225:linux@dominikbrodowski.net::gzLtlcbAjIT9xjsI:0000000000000000000000000000000000hfqTA
X-Hashcash: 1:30:101225:davej@redhat.com::7cii0icWH9OMhUn7:a6QrD
X-Hashcash: 1:30:101225:youquan.song@intel.com::MRChgV/+Ys395I2T:00000000000000000000000000000000000000IPrQQ
X-Hashcash: 1:30:101225:cpufreq@vger.kernel.org::JheffWoAReD16mHy:0000000000000000000000000000000000000eexmP
X-Hashcash: 1:30:101225:venki@google.com::h91niayxFPzDcpld:3Wf35
X-Hashcash: 1:30:101225:arjan@linux.intel.com::JQ8Lnv2NkHNLoX83:0000000000000000000000000000000000000008j+of
X-Hashcash: 1:30:101225:lenb@kernel.org::Ve5/GX5lCjuWUWAu:0EyIX9
X-Hashcash: 1:30:101225:suresh.b.siddha@intel.com::Zl5fR3ltEd00/LEd:00000000000000000000000000000000000OL7kk
X-Hashcash: 1:30:101225:kent.liu@intel.com::1KPUrHg2bmOQZD99:000000000000000000000000000000000000000000f2FO+
X-Hashcash: 1:30:101225:chaohong.guo@intel.com::VluEX3ybjnBkCpGd:00000000000000000000000000000000000000XZMm3
X-Hashcash: 1:30:101225:linux-kernel@vger.kernel.org::jBAvV+5QZMhS+fEC:00000000000000000000000000000000OP3Qp
X-Hashcash: 1:30:101225:linux-acpi@vger.kernel.org::cGMnoKS0WwehdHA1:0000000000000000000000000000000000KXK5s
X-Hashcash: 1:30:101225:youquan.song@linux.intel.com::TPPxo4CVZEnyh6rQ:00000000000000000000000000000000WoQuk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "DB" == Dominik Brodowski <linux@dominikbrodowski.net> writes:

DB> AFAICS, we have two in-kernel dynamic frequency scaling governors, one of
DB> which doesn't seem to get much usage (conservative)...

Isn't conservative the recommended choice for AMD processors?

Or has that changed?

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
