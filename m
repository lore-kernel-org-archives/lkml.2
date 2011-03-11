Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab1CKQXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 11:23:36 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:30443 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751948Ab1CKQXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 11:23:35 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: CA5bHaYVM1nRb2TmhX5Sw8PmDGw.JIJWkvh6MocrQOEZzlq
 SSBtx8WbKWOrFMULB1JqEyWxMO_OhlM_2CDEdOfe0d40F3yXIc8WlRiOU25t
 J62JmjfjlycePcA0uHAzDL3T.ypifhh29rn2alCp36X8OuRmTS_O5aYmnB.w
 OF5L7CQ3XnPOEnt2H9YBo5.51o79qqftFefRdAf3EVcH47ZmCuJ.PzFmrJWi
 r9TIToMXPnJ_k5SfUtEubEoyEfJccvdSOcm0-
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110311162310.124405247@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 11 Mar 2011 10:23:10 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [x86 this_cpu_has V1 0/4] Use cpu ops to implement this_cpu_has and use it in various places
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches were posted earlier in the context of this_cpu_ops use cases.
Tejun send them to the x86 maintainers but they seem to have gotten lost.

