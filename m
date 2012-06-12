Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab2FLVh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 17:37:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46072 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab2FLVh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 17:37:26 -0400
Message-ID: <4FD7B68F.9010000@zytor.com>
Date: Tue, 12 Jun 2012 14:37:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Brandon Falk <bfalk@gamozolabs.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [question] x86/x86_64 boot process
References: <CAK9+cJX9GHjToKbOqqmink5Kr-9y3ZhQPC8M8rcL70rWbbYVYw@mail.gmail.com> <4FD7AF24.8080607@zytor.com> <CAK9+cJXLYX_20Xovy5Th7aXcznVf--RzF+GxxOWiv2gX6pETng@mail.gmail.com> <4FD7B1AB.6030708@zytor.com> <CAK9+cJX9dSf0H9_W-HjQK3t6DUVtQnvfd-+e_hTUYTuNXnWT=A@mail.gmail.com> <CAK9+cJW=YLGXCLRM4+MCgkQpFkp5Q6+K4v44MA6xL54GFA7a_A@mail.gmail.com>
In-Reply-To: <CAK9+cJW=YLGXCLRM4+MCgkQpFkp5Q6+K4v44MA6xL54GFA7a_A@mail.gmail.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2012 02:33 PM, Brandon Falk wrote:
> Would it be reasonable to put the setup code at 0x7c00 (given that I
> can fit my boot loader in the space before the kernel header)?

Should work.

	-hpa

