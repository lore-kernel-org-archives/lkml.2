Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab1C2QpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 12:45:22 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58417 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890Ab1C2QpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 12:45:19 -0400
Message-ID: <4D920C9B.5070405@linux.vnet.ibm.com>
Date: Tue, 29 Mar 2011 12:45:15 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
CC: debora@linux.vnet.ibm.com, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com, preining@logic.at
Subject: Re: [patch 1/8] tpm_tis: Use timeouts returned from TPM
References: <20110315111307.895085413@linux.vnet.ibm.com> <20110315111425.620707275@linux.vnet.ibm.com> <4D91EE00.1000801@linux.vnet.ibm.com>
In-Reply-To: <4D91EE00.1000801@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2011 10:34 AM, Rajiv Andrade wrote:
> Hi Stefan,
>
> Some comments:
>
> On 03/15/2011 08:13 AM, Stefan Berger wrote:
>> v3:
>> - sysfs entry now called 'durations' to resemble TPM-speak (previously
>>    was called 'timeouts')
>>
>> v2:
>> - adjusting all timeouts for TPM devices reporting timeouts in msec rather
>>    than usec
> This is a bugfix that's different than the one you originally sent, can you
> submit this as a separated patch? This is mainly for easier debug in the
> future, so each feature/bugfix/commit can be tested separately.
Originally I sent a patch that corrected the evaluation of the return 
code within the TPM's response and introduced the sysfs entry. I did not 
scale the MEDIUM and LONG timeouts, which then caused the problems on 
the Infineon TPM and the patch was removed. I then introduced the 
scaling of the MEDIUM and LONG timeouts, which seems necessary as a 
consequence to working with the TPM-reported timeouts. Then adding a 
sysfs entry to it is an additional feature. I'd split this patch in 2 
patches where the 2nd one introduces the sysfs entry. Is this ok with you?

    Stefan

