Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab1DQJoZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 05:44:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804Ab1DQJoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 05:44:19 -0400
Message-ID: <4DAAB66E.6010105@redhat.com>
Date: Sun, 17 Apr 2011 12:44:14 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Nelson Elhage <nelhage@ksplice.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: emulator: Handle wraparound in (cs_base + offset)
 when fetching.
References: <1302709453-19031-1-git-send-email-nelhage@ksplice.com>
In-Reply-To: <1302709453-19031-1-git-send-email-nelhage@ksplice.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2011 06:44 PM, Nelson Elhage wrote:
> Currently, setting a large (i.e. negative) base address for %cs does not work on
> a 64-bit host. The "JOS" teaching operating system, used by MIT and other
> universities, relies on such segments while bootstrapping its way to full
> virtual memory management.

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

