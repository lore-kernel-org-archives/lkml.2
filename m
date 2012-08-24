Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab2HXE04 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 00:26:56 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37872 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab2HXE0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 00:26:54 -0400
MIME-Version: 1.0
Date: Thu, 23 Aug 2012 23:26:52 -0500
Message-ID: <CAOA0mo_-b3=mn5hKBE1S5s7_2tsnV42bFSe9v9Uj-Vmk4s54rQ@mail.gmail.com>
Subject: "Trapping" hard drive errors ( "ata***** failed command: READ FPDMA QUEUED")
From: Mouse Dresden <mouse.the.lucky.dog@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello I hope that this question is not to mundane.

A while ago I encountered this error message on a hard drive of mine.
I managed to clean up the problem and run smartctl and the disk is
clean, but such errors can be very problematic. I think one of the
reasons is that the hard drive gets "bogs down" on the particular
command and communication between the kernel and drive, other system
calls time out. This generates a lot of spurious errors you have to
eliminate.

I would like to create some basic tools to aid in diagnosing and
repairing such problems. The main difficulty is "trapping" the error
message. By this I mean terminating the call that is causing the
error, causing the drive to abandon this particular command, and
sending some sort of signal ( figurative and or literal ) to the
process making the particular command, so I can trace it.

Can someone either describe the process, or if it is too long,
recommend some reading describing it?

If it helps to know the detailed message, it can be found at:
http://unix.stackexchange.com/questions/43681/kde-causes-read-fpdma-queued-error

Thank you
