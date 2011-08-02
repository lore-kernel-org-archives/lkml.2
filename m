Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab1HBR6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 13:58:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44120 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766Ab1HBR6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 13:58:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAN8TOE9mWEmS5YJqNrS9OrG=t+emeLcXNpKR1BiZ6VDJW7_c=A@mail.gmail.com>
References: <CAGq3pz4LHRkCqaJfqoMYe-=mn+s5CVZipab7bd8F3z+ou3xxVA@mail.gmail.com>
	<CAN8TOE9mWEmS5YJqNrS9OrG=t+emeLcXNpKR1BiZ6VDJW7_c=A@mail.gmail.com>
Date: Tue, 2 Aug 2011 18:58:09 +0100
X-Google-Sender-Auth: HyleuqOsE8Dg8vXYzk7Jfj4jT78
Message-ID: <CAGq3pz7i3mBnLjK+wne5sgkk2ko4d8K8571eFvD8Y=X6CpU=PA@mail.gmail.com>
Subject: Re: MTD-related kobject badness during linux-next boot
From: Daniel Drake <dsd@laptop.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 August 2011 18:40, Brian Norris <computersforpeace@gmail.com> wrote:
> Have you tried linux 3.0, which does not have the patch series that
> messes with mtd partition parsing and registering?

Yes, and the problem does not appear there.

Daniel
