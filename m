Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab1E2KW4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 06:22:56 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:26539 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751301Ab1E2KWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 06:22:55 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAPId4k1XQJkV/2dsb2JhbABVpj94xneGHgSVDYpe
Message-ID: <4DE21E3D.70105@computer.org>
Date: Sun, 29 May 2011 12:21:49 +0200
From: Jan Ceuleers <jan.ceuleers@computer.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/3] x86, intel: Output microcode revision
References: <1306278210-18285-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1306278210-18285-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/05/11 01:03, Andi Kleen wrote:
> From: Andi Kleen<ak@linux.intel.com>
>
> I got a request to make it easier to determine the microcode update level
> on Intel CPUs. This patch adds a new "cpu update" field to /proc/cpuinfo,
> which I added at the end to minimize impact on parsers.
>
> The update level is also outputed on fatal machine checks together
> with the other CPUID model information.


s/outputed/output/

Jan
