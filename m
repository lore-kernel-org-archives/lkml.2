Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab2AVSbA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 13:31:00 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38099 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab2AVSa7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 13:30:59 -0500
MIME-Version: 1.0
In-Reply-To: <CAGAKE886que4x4h7N7fszGQXKE3Fej_yAShjOiKEEZrL5Gocbw@mail.gmail.com>
References: <CAGAKE8_zLr9nrQ_-cXQGzycFo6746t8OzKK6DpCd9tcahyRfPQ@mail.gmail.com>
	<CAGAKE8_wL0GcbjDNWOw4sa8euxZyGDgkdW9EgohpmG48Qk3-nQ@mail.gmail.com>
	<CAO+b5-pZofpN7-e8H+toE98j24fby5u8_Nzfzkz_S31u5wDmwA@mail.gmail.com>
	<CAGAKE88--L1igeZFusU=TxRD6fyfKWZYhn7az6-xkS_mtVg8CA@mail.gmail.com>
	<CAGAKE8_b_Omxzg4C-VMiuM9aEhnRPkPD9=5DW9retGfcfOhBuQ@mail.gmail.com>
	<CAGAKE8-3k0FN5B91ff2XFpYuHfwB-bmr4b7EBEe-aSWfQr1mSw@mail.gmail.com>
	<CAO+b5-qsdn8i_BdAqJo_6CU3Lh6JTPSSsyg-m_bP+xcN5aBgxg@mail.gmail.com>
	<CAGAKE886que4x4h7N7fszGQXKE3Fej_yAShjOiKEEZrL5Gocbw@mail.gmail.com>
Date: Sun, 22 Jan 2012 18:30:57 +0000
X-Google-Sender-Auth: CsaIJV-bocVYfTdVvZIsRvxXDb0
Message-ID: <CAO+b5-rdNTk=P16=k1CxL=rkVEDUubCAmw+oaRmJ4hsCurrPog@mail.gmail.com>
Subject: Re: [Scst-devel] BUG: Process hang when kvm crashed, stacktrace cfs+kvm
From: Bart Van Assche <bvanassche@acm.org>
To: kordex <kordex@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu, peterz@infradead.org,
        kvm@vger.kernel.org, avi@redhat.com,
        scst-devel <scst-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 21, 2012 at 9:19 PM, kordex <kordex@gmail.com> wrote:
> I hit sysrq+t sysrq+p in order to print the tasks with stacktraces and
> registers. Using ps -e -o  pid,state,command will hang ps output,
> while ps -e -o pid,state will not.

Sorry, haven't seen such a hang ever before. Does it also occur with
older kernels than 3.1 ? Is it reproducible with 3.3-rc1 ?

Bart.
