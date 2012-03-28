Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496Ab2C1Rmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 13:42:37 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:40072 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932365Ab2C1RmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 13:42:09 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: mingo@elte.hu, suresh.b.siddha@intel.com, jwboyer@redhat.com
Cc: hpa@zytor.com, yinghai@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: add io_apic_ops to allow interception
Date: Wed, 28 Mar 2012 13:37:20 -0400
Message-Id: <1332956242-5352-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <20120328092358.GD22885@gmail.com>
References: <20120328092358.GD22885@gmail.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090203.4F734D64.0003,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Done. I've put them on: git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-ingo-3.4.v2

and I am also attaching them here for your convenience.

They differ a bit from the previous one - the 'x86_io_apic' is now
called 'x86_io_apic_ops'  - otherwise the warning of functions referencing
the __init function would show up - but otherwise they are exactly the same.
