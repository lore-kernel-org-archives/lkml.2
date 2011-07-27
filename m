Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab1G0LlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 07:41:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435Ab1G0LlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 07:41:17 -0400
Message-ID: <4E2FF957.1040207@redhat.com>
Date: Wed, 27 Jul 2011 14:41:11 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Mike Waychison <mikew@google.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: Really fix HV_X64_MSR_APIC_ASSIST_PAGE
References: <1311406305-24523-1-git-send-email-mikew@google.com>
In-Reply-To: <1311406305-24523-1-git-send-email-mikew@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2011 10:31 AM, Mike Waychison wrote:
> Commit 0945d4b228 tried to fix the get_msr path for the
> HV_X64_MSR_APIC_ASSIST_PAGE msr, but was poorly tested.  We should be
> returning 0 if the read succeeded, and passing the value back to the
> caller via the pdata out argument, not returning the value directly.

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

