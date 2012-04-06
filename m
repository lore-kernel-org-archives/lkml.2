Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab2DFSLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 14:11:16 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:43144 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab2DFSLN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 14:11:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo4kd6Q=cNMp6GJV6MBN9uypRCJB0sNfrkq9vpXDTtqzAg@mail.gmail.com>
References: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
	<1332135996-13860-41-git-send-email-yinghai@kernel.org>
	<4F7F10C5.1050901@gmail.com>
	<CAE9FiQUEJ4Jvz0BHJ8LCBNpXWB3Cf6u3k9F1avAd4a-fkGOB=Q@mail.gmail.com>
	<CAErSpo6gitMTVXeMBOSJFRHvQT_iJ-RGmLduYsGEM+3YAPE2CQ@mail.gmail.com>
	<CAE9FiQUjsiEvGGZz4sPux5AM7ipDsqgqgh5bh2QA7GJVBTqDKw@mail.gmail.com>
	<CAE9FiQWjLx8R_j5q1qF-NYLOmxV-TbmROUqcLMw-QMFE4rjkpw@mail.gmail.com>
	<CAErSpo4kd6Q=cNMp6GJV6MBN9uypRCJB0sNfrkq9vpXDTtqzAg@mail.gmail.com>
Date: Fri, 6 Apr 2012 11:11:13 -0700
X-Google-Sender-Auth: v84gdO8903rpdnce_lYcInYwK3k
Message-ID: <CAE9FiQV6iNdTz1tjZ1-kJENDujJRtYGVnD4BuVhfp0dcKLP=XQ@mail.gmail.com>
Subject: Re: [PATCH -v3 40/47] PCI: Add pci bus removal through /sys/.../pci_bus/.../remove
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 6, 2012 at 11:05 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> But I'm not aware of cases where we can hotplug non-ACPI host bridges,
> so I don't understand the value of supporting this.  Is this related
> to the cases where we blindly probe and discover CPU memory
> controllers and things that the BIOS decided not to expose to the OS?

Yes.

Let's drop the last 8 patches in this patchset. I will keep them local
for debug purpose.

Yinghai
