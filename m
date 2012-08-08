Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302Ab2HHU5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 16:57:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757380Ab2HHU5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 16:57:09 -0400
Message-ID: <5022D29B.9000402@redhat.com>
Date: Wed, 08 Aug 2012 22:56:59 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Thunderbird/5.0
MIME-Version: 1.0
To: Wesley Miaw <wmiaw@netflix.com>
CC: Mikulas Patocka <mpatocka@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        Alasdair Kergon <agk@redhat.com>, "msb@google.com" <msb@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?windows-1252?Q?Will_Drewry=99?= <w@google.com>
Subject: Re: [dm-devel] [PATCH] dm: verity support data device offset (Linux
 3.4.7)
References: <8893CF66-2E2C-4D8F-9239-E38BE55716AE@netflix.com> <Pine.LNX.4.64.1208081437550.16469@file.rdu.redhat.com> <5022CC99.30103@redhat.com> <AD722D70-2E9C-4B2D-BE48-B94E2268C3DD@netflix.com>
In-Reply-To: <AD722D70-2E9C-4B2D-BE48-B94E2268C3DD@netflix.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2012 10:46 PM, Wesley Miaw wrote:
> On Aug 8, 2012, at 1:31 PM, Milan Broz wrote:

> I did modify veritysetup on my own so the format and verify commands will work with regular files on disk instead of having to mount through loop devices.

Which veritysetup? In upstream (cryptsetup repository) it allocates loop automatically.
(And for userspace verification it doesn't need loop at all.)

Anyway, please send a patch for userspace as well then ;-)

Milan
