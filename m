Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab1HOUEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 16:04:08 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38121 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab1HOUEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 16:04:04 -0400
MIME-Version: 1.0
Date: Mon, 15 Aug 2011 14:04:03 -0600
Message-ID: <CAGRJchidA8ZTMcJnmfJpoBjjpG1zYFC4XQT8KKxjQUm4o3CCng@mail.gmail.com>
Subject: [RFC] Moving magnetometer HMC6352 into IIO subsystem
From: Jonathan Kunkee <jonathan.kunkee@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-iio@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

Should the HMC6352 digital compass driver (drivers/misc/hmc6352.c)
be moved under the IIO subsystem (drivers/staging/iio/magnetometer)?

Magnetometers act as ADCs and can have high sampling rates and
complex internals, so I think that according to
drivers/staging/iio/Documentation/overview.txt they should almost always
land in IIO land.

I would be willing to work on the change as I want to submit a similar
driver for the HMC6343 magnetometer/accelerometer as well.

Thanks!
Jon Kunkee
