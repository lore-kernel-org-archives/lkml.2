Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab0GHPCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 11:02:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48372 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755964Ab0GHPCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 11:02:31 -0400
Message-ID: <4C35E873.30502@zytor.com>
Date: Thu, 08 Jul 2010 08:02:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
CC: "mingo@redhat.com" <mingo@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/cpu] x86, cpu: AMD errata checking framework
References: <1276681733-10872-1-git-send-email-hans.rosenfeld@amd.com> <tip-48327dd572aaf9924c3dc4f8ad3189d506b11390@git.kernel.org> <4C34B5CE.1040407@zytor.com> <20100708141845.GI11824@escobedo.osrc.amd.com>
In-Reply-To: <20100708141845.GI11824@escobedo.osrc.amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Something else you might want to consider is exporting this information
in /proc/cpuinfo or similar.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

