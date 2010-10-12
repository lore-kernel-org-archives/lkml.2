Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127Ab0JLU0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 16:26:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35499 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077Ab0JLU0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 16:26:08 -0400
Message-ID: <4CB4C448.1030201@zytor.com>
Date: Tue, 12 Oct 2010 13:25:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: ling.ma@intel.com
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] [X86/mem] Handle unaligned case by avoiding store
 crossing cache line
References: <1286916487-11967-1-git-send-email-ling.ma@intel.com>
In-Reply-To: <1286916487-11967-1-git-send-email-ling.ma@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay...

All in all looks good, but what about other misalignments than 0 or 4?

	-hpa
