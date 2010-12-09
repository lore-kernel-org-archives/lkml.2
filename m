Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab0LIXMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 18:12:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36774 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408Ab0LIXMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 18:12:16 -0500
Message-ID: <4D016241.5090503@zytor.com>
Date: Thu, 09 Dec 2010 15:12:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: x86@kernel.org, linux-acpi@vger.kernel.org, lenb@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ACPICA: Fix access width for reset vector
References: <1291931204-5854-1-git-send-email-mjg@redhat.com> <1291931204-5854-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1291931204-5854-2-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2010 01:46 PM, Matthew Garrett wrote:
> Section 4.7.3.6 of the ACPI specification requires that the register width
> of the reset vector be 8 bits. Windows simply hardcodes the access to be
> a byte and ignores the width provided in the FADT, so make sure that we
> do the same.
>
> Signed-off-by: Matthew Garrett<mjg@redhat.com>

Does anyone have an acpidump from a machine with an ALi 1535 southbridge?

	-hpa
