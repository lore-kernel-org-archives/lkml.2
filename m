Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab0EWWBJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 18:01:09 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41718 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab0EWWBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 18:01:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=rgZ0vcxPkXlEZidV6WwgsrbRo2f0YCT8RM96CjmNgtmfGK0tNrIijUO5bjqB7jRZWX
         nH7OCkmtr96AzYZQp59Ov3IBGzBsx1kiiT8IIqzGfdlIHhrQhXoarbMq4vv8oEVKkeY5
         Fkf5hnr9/lp4OJSsL5LA3PAh5w+BpcJD9fIGA=
MIME-Version: 1.0
Date: Mon, 24 May 2010 00:01:04 +0200
Message-ID: <AANLkTim9WljDjX-dMSJ3oCHxZu8-0iaz6UsAcZwXC6n8@mail.gmail.com>
Subject: How large is a sector in /proc/diskstats
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In /proc/diskstats a filed logs how many sectors have been written to a device.
But how large is a sector?

If its device dependent, how can I find it out?

Thanks, Clemens
