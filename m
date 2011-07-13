Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab1GMDVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 23:21:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55077 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932349Ab1GMDVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 23:21:43 -0400
Message-ID: <4E1D0F33.7020708@zytor.com>
Date: Tue, 12 Jul 2011 20:21:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Tejun Heo <tj@kernel.org>, mingo@redhat.com, tglx@linutronix.de,
        benh@kernel.crashing.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCHSET x86/mm] memblock, x86: Allow node info in memblock
 and remove x86 specific memblock code
References: <1310462166-31469-1-git-send-email-tj@kernel.org> <CAE9FiQUfHB=EtzDBhPr2ntn__0AC0NcCdi0e7NiwmKb0bZmBbg@mail.gmail.com>
In-Reply-To: <CAE9FiQUfHB=EtzDBhPr2ntn__0AC0NcCdi0e7NiwmKb0bZmBbg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2011 04:26 PM, Yinghai Lu wrote:
> 
> that is great, merge early_node_map into memblock array.
> 
> looks it comes with some mismatch section warning...
> 

I'm also confused about the baseline of the patchset...

	-hpa
