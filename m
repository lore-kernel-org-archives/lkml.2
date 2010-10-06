Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314Ab0JFWZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 18:25:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46918 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab0JFWZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 18:25:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=D22fXfcHfshHOKIHCiFlMcgtaTpBfcUYBhBhYEk6X/rB+rIODuhpG6EVwugBoXwrXO
         jDlnTHggcLeto4E7BPML9NOZGHYt7v5QmQGbH+VG6TJRGySfZV0LLu2HZF8PoeLmCh1V
         QDtKK9mKt1ImzrlD7Vb0IfvU2u9M3su2A+g3k=
MIME-Version: 1.0
Date: Wed, 6 Oct 2010 20:25:09 -0200
Message-ID: <AANLkTikUoNwzHNyuWNGgJ6QkMNbbyTG7SmMQqZaR1E9_@mail.gmail.com>
Subject: ask about include header file
From: khaled MOHAMMED atteya <khaled.m.atteya@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In arch/x86/kernel/entry_32.S(for example) , audit_syscall_entry
function is called by this statement "call audit_syscall_entry", and
when i search about this function declaration , i found it in
include/linux/audit.h , but i couldn't found #include linux/audit.h in
entry_32.S as i expected, why?

-- 
WITH MY RESPECT
Khaled.M.Atteya
