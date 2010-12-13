Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab0LMItn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 03:49:43 -0500
Received: from adelie.canonical.com ([91.189.90.139]:33567 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501Ab0LMItl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 03:49:41 -0500
Message-ID: <4D05DE18.3060500@canonical.com>
Date: Mon, 13 Dec 2010 16:49:28 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Corentin Chary <corentin.chary@gmail.com>
CC: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-acpi@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 0/7] ideapad: hotkey enablement
References: <1291881376-4729-1-git-send-email-ike.pan@canonical.com> <AANLkTimUpXe34tSzvOJ_oo=fyqdAhwkk6xnN10BbdWrH@mail.gmail.com>
In-Reply-To: <AANLkTimUpXe34tSzvOJ_oo=fyqdAhwkk6xnN10BbdWrH@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2010 04:39 PM, Corentin Chary wrote:
>> acpi_handle is still a global variable becuase we need to pass handle pointer
>> to rfk_set with its opcode but only one data argument available.
> 
> Of course there is only one data argument available, but since it's a
> void *, you
> can use a struct with your handle and the opcode :).
> 

I have tried it. It needs to copy the same handle three times to each struture.
Since we only have an acpi handle, I think to have it global will let driver
easy read.
