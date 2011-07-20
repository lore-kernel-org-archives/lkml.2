Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab1GTNHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 09:07:20 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54824 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab1GTNHT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 09:07:19 -0400
MIME-Version: 1.0
In-Reply-To: <CA+QbAV5m5rqdW-hNAicEeqB0whpsMKXzvWhp0_7nFbPrEPikwg@mail.gmail.com>
References: <CA+QbAV5m5rqdW-hNAicEeqB0whpsMKXzvWhp0_7nFbPrEPikwg@mail.gmail.com>
Date: Wed, 20 Jul 2011 06:07:18 -0700
Message-ID: <CA+QbAV5PZs2VpB02z0EWeOuwpM1=0Tec+t7MvwhPVxMNp=jytw@mail.gmail.com>
Subject: Re: MSI-X PBA array
From: Kallol Biswas <nucleodyne@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
    We are trying to understand how linux kernel code accesses and
utilizes MSI-X PBA (Pending Bit Array) array.
There is a MSI-X howto document that mentions about PBA array but we
could not locate in kernel where it is accessed and used.

Any help to locate the code that uses the array will be appreciated.

Kallol
