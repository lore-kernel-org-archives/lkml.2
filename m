Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab0IVP4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 11:56:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49602 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298Ab0IVP4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 11:56:39 -0400
Message-ID: <4C9A271F.30608@zytor.com>
Date: Wed, 22 Sep 2010 08:56:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, yinghai@kernel.org,
        just.for.lkml@googlemail.com, tglx@linutronix.de, hpa@linux.intel.com
Subject: Re: Early console confusion
References: <4C7B0578.8090807@kernel.org> <tip-83d9f65bdae6f6b34d75282c6618d3f50846849a@git.kernel.org> <201009220912.45360.bjorn.helgaas@hp.com>
In-Reply-To: <201009220912.45360.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2010 08:12 AM, Bjorn Helgaas wrote:
> Can somebody explain the differences between
> 
> 	earlycon=uart,...
> 	earlycon=uart8250,...
> 	earlyprintk=serial,...
> 	console=uart,...
> 	console=uart8250,...
> 
> I'm not really convinced we need them all, and it's getting a
> little confusing.
> 

Some of them come from the embedded industry, where it's felt that you
have to be able to specify the exact parameters because there are no
standards, and some come from the PC world where "serial port 0" is a
well-defined concept and noone wants to bloody call it "uart8250,0x3f8".

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

