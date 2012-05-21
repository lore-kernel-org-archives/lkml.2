Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab2EUSFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 14:05:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44451 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758628Ab2EUSF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 14:05:29 -0400
Message-ID: <4FBA83D5.9030506@zytor.com>
Date: Mon, 21 May 2012 11:05:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, relocs: build clean fix
References: <1337622684-6834-1-git-send-email-jarkko.sakkinen@intel.com> <20120521180134.GA5890@merkur.ravnborg.org>
In-Reply-To: <20120521180134.GA5890@merkur.ravnborg.org>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2012 11:01 AM, Sam Ravnborg wrote:
> On Mon, May 21, 2012 at 08:51:24PM +0300, Jarkko Sakkinen wrote:
>> relocs was not cleaned up when "make clean" is issued. This
>> patch fixes the issue.
>>
>> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
> 
> Stable candidate?
> 

Yes, I'll queue this up as urgent.

	-hpa


