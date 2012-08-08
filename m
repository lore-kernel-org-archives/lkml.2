Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251Ab2HHUbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 16:31:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822Ab2HHUbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 16:31:32 -0400
Message-ID: <5022CC99.30103@redhat.com>
Date: Wed, 08 Aug 2012 22:31:21 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Thunderbird/5.0
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>
CC: device-mapper development <dm-devel@redhat.com>,
        Alasdair Kergon <agk@redhat.com>, "msb@google.com" <msb@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?windows-1252?Q?Will_Drewry=99?= <w@google.com>, wmiaw@netflix.com
Subject: Re: [dm-devel] [PATCH] dm: verity support data device offset (Linux
 3.4.7)
References: <8893CF66-2E2C-4D8F-9239-E38BE55716AE@netflix.com> <Pine.LNX.4.64.1208081437550.16469@file.rdu.redhat.com>
In-Reply-To: <Pine.LNX.4.64.1208081437550.16469@file.rdu.redhat.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2012 08:46 PM, Mikulas Patocka wrote:

> The problem with the patch is that it changes interface to the userspace 
> tool. The userspace tool veritysetup already exists in recent cryptsetup 
> package, so we can't change the interface - you should change the patch so 
> that the starting data block is the last argument and the argument is 
> optional - so that it is compatible with the existing userspace too.

yes. Please never change interface without at least increasing target version.

I have to add userspace support as well to veritysetup and we need a way
how to detect that option is supported by running kernel.

Milan
