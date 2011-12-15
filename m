Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932Ab1LOPq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 10:46:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40174 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452Ab1LOPq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 10:46:56 -0500
Message-ID: <4EEA1664.1050402@zytor.com>
Date: Thu, 15 Dec 2011 07:46:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Mike Waychison <mikew@google.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 3/4] EFI: Add support for variables longer than 1024 bytes
References: <1323896791-10858-1-git-send-email-mjg@redhat.com> <1323896791-10858-4-git-send-email-mjg@redhat.com> <CAGTjWtCpt_1h6XMwCFkx1TQnQbagtSuFBejcp6XNr4yhKgNuLg@mail.gmail.com> <20111214223950.GA29264@srcf.ucam.org> <CAGTjWtARm_OA0qy2Cvtc-rrPFpH2+2QdFw4CvBAo-PJsfX6t6w@mail.gmail.com> <20111215154356.GA10486@srcf.ucam.org>
In-Reply-To: <20111215154356.GA10486@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2011 07:43 AM, Matthew Garrett wrote:
>
> We'll pretty much definitely want to be able to read values>  1024 once
> people start shoving keys in there. The PAGE_SIZE limit is one that I'd
> forgotten about, though.
>

The jump from 1024 to 4096 seems to not be very long... hence I think we 
may need a different approach.
