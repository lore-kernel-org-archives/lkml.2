Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab1AHAdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 19:33:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36416 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab1AHAdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 19:33:04 -0500
Message-ID: <4D27B0B7.5060102@zytor.com>
Date: Fri, 07 Jan 2011 16:32:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [GIT PULL] percpu changes for 2.6.38
References: <20110107221448.GA9884@mtj.dyndns.org>
In-Reply-To: <20110107221448.GA9884@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2011 02:14 PM, Tejun Heo wrote:
> Pulling this branch into the current master (01539ba2) causes three
> conflicts under arch/x86.  This is because merging percpu into x86
> seemed to make the dependency a bit too hairy causing changes applying
> this_cpu_*() ops to arch/x86 code conflict with other x86 changes.

For the record, this flow was ACKed by myself and Ingo.

	-hpa
