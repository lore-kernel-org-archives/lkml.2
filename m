Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab1HBSGD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 14:06:03 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:48183 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab1HBSF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 14:05:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAGq3pz7i3mBnLjK+wne5sgkk2ko4d8K8571eFvD8Y=X6CpU=PA@mail.gmail.com>
References: <CAGq3pz4LHRkCqaJfqoMYe-=mn+s5CVZipab7bd8F3z+ou3xxVA@mail.gmail.com>
	<CAN8TOE9mWEmS5YJqNrS9OrG=t+emeLcXNpKR1BiZ6VDJW7_c=A@mail.gmail.com>
	<CAGq3pz7i3mBnLjK+wne5sgkk2ko4d8K8571eFvD8Y=X6CpU=PA@mail.gmail.com>
Date: Tue, 2 Aug 2011 11:05:54 -0700
Message-ID: <CAN8TOE-c8f46PCtJx5jhp=s61SxTwep-t2YdybDnTYYufbOT-g@mail.gmail.com>
Subject: Re: MTD-related kobject badness during linux-next boot
From: Brian Norris <computersforpeace@gmail.com>
To: Daniel Drake <dsd@laptop.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 2, 2011 at 10:58 AM, Daniel Drake <dsd@laptop.org> wrote:
> On 2 August 2011 18:40, Brian Norris <computersforpeace@gmail.com> wrote:
>> Have you tried linux 3.0, which does not have the patch series that
>> messes with mtd partition parsing and registering?
>
> Yes, and the problem does not appear there.

As expected. Then let's wait and see if anyone has comments on my patch.

Brian
