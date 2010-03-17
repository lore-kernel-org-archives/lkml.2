Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab0CQJxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 05:53:33 -0400
Received: from mail-iw0-f176.google.com ([209.85.223.176]:40735 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab0CQJxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 05:53:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=oh611pb7vy0dTkzQvcsa1SK256dGNoYS6kN9OpBeS4UsxeB9P6N2Bk5HkqsSYqOgvu
         elRM16oTj+a6Y0dW4kzO7tE7lnGZkqKJXeFYnNcNYRhTcF/L88632S6O05SA63Cn2opC
         tCUn4g7Zropy01vSnvfFQ4dDiWTCrs84ha/3I=
MIME-Version: 1.0
Date: Wed, 17 Mar 2010 05:53:30 -0400
Message-ID: <5d592f661003170253h2a34219cif6d560af6454c8a6@mail.gmail.com>
Subject: Can not get 'function_graph' for
From: Ryan Wang <openspace.wang@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

        I have build 2.6.33.1 with ftrace on, but after reboot
I cannot get function_graph from available_tracers.
===============
# .config
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_GENERIC_TRACER=y
CONFIG_FUNCTION_TRACER=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_SYSPROF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_BOOT_TRACER=y
CONFIG_BRANCH_TRACER=y
# CONFIG_POWER_TRACER is not set
CONFIG_KSYM_TRACER=y
# CONFIG_PROFILE_KSYM_TRACER is not set
CONFIG_STACK_TRACER=y
CONFIG_WORKQUEUE_TRACER=y


======================================
# cat available_tracers
ksym_tracer blk kmemtrace branch mmiotrace wakeup_rt wakeup irqsoff
function sched_switch initcall nop
