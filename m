Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab1IRNao (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 09:30:44 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:48136 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750844Ab1IRNao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 09:30:44 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtQFAMjwdU5XQAOS/2dsb2JhbABBhFWgdIF9eIFTAQEFIxUeIgEQCxgCAgUWCwICCQMCAQIBJx4GDQEHAQGHdaUZkC6BLIQ7gREEmGaMEg
Message-ID: <4E75F264.2030105@computer.org>
Date: Sun, 18 Sep 2011 15:30:12 +0200
From: Jan Ceuleers <jan.ceuleers@computer.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Xavier Roche <roche*lkml@httrack.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Follow-up to routing IPv6 source address selection bug in kernel
References: <4E75E754.2080900@httrack.com>
In-Reply-To: <4E75E754.2080900@httrack.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2011 02:43 PM, Xavier Roche wrote:
> Hi folks,
>
> I reported a year ago a bug regarding source address selection in the
> kernel for Ipv6, but it seem to be still there. If anyone has any
> insightful advice on possible workarounds, or (better) possible fixes,
> it would be great.
Please report networking issues to netdev.
