Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933782Ab0DHW7B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 18:59:01 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:52376 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933762Ab0DHW7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 18:59:00 -0400
Date: Thu, 8 Apr 2010 15:57:18 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Subject: trace-cmd: trace.dat file format doc fixes
Message-Id: <20100408155718.8673c823.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4BBE5FB0.00C6:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Typo/grammo corrections to trace-cmd.dat.5.txt:

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/trace-cmd.dat.5.txt |   58 ++++++++++++++--------------
 1 file changed, 29 insertions(+), 29 deletions(-)

--- trace-cmd-0.7.0.orig/Documentation/trace-cmd.dat.5.txt
+++ trace-cmd-0.7.0/Documentation/trace-cmd.dat.5.txt
@@ -29,7 +29,7 @@ INITIAL FORMAT
 
      "tracing"
 
-  The next set of characters contain a null '\0' terminated string,
+  The next set of characters contain a null '\0' terminated string
   that contains the version of the file (for example):
 
      "6\0"
@@ -41,15 +41,15 @@ INITIAL FORMAT
 
   The next byte contains the number of bytes per "long" value:
 
-     4 - 32 bit long values
-     8 - 64 bit long values
+     4 - 32-bit long values
+     8 - 64-bit long values
 
   Note: This is the long size of the target's userspace. Not the
   kernel space size.
 
-  [ Now all numbers are written in file defined endianess ]
+  [ Now all numbers are written in file defined endianess. ]
 
-  The next 4 bytes is a 32 bit word that defines what the traced
+  The next 4 bytes are a 32-bit word that defines what the traced
   host machine page size was.
 
 HEADER INFO FORMAT
@@ -62,28 +62,28 @@ HEADER INFO FORMAT
 
     "header_page\0"
 
-  The next 8 bytes is a 64 bit word containing the size of the
+  The next 8 bytes are a 64-bit word containing the size of the
   page header information stored next.
 
   The next set of data is of the size read from the previous 8 bytes,
-  and contains the data retrieved from debugfs/tracing/events/header_page
+  and contains the data retrieved from debugfs/tracing/events/header_page.
 
   Note: The size of the second field \fBcommit\fR contains the target
   kernel long size. For example:
 
   field: local_t commit;	offset:8;	\fBsize:8;\fR	signed:1;
 
-  Shows the kernel has a 64 bit long.
+  shows the kernel has a 64-bit long.
 
   The next 13 bytes contain the string:
 
   "header_event\0"
 
-  The next 8 bytes is a 64 bit word containing the size of the
+  The next 8 bytes are a 64-bit word containing the size of the
   event header information stored next.
 
   The next set of data is of the size read from the previous 8 bytes
-  and contains the data retrieved from debugfs/tracing/events/header_event
+  and contains the data retrieved from debugfs/tracing/events/header_event.
 
   This data allows the trace-cmd tool to know if the ring buffer format
   of the kernel made any changes.
@@ -95,7 +95,7 @@ FTRACE EVENT FORMATS
   the Ftrace specific events. These are the events used by the Ftrace plugins
   and are not enabled by the event tracing.
 
-  The next 4 bytes contains a 32 bit word of the number of Ftrace event
+  The next 4 bytes contain a 32-bit word of the number of Ftrace event
   format files that are stored in the file.
 
   For the number of times defined by the previous 4 bytes is the
@@ -112,7 +112,7 @@ EVENT FORMATS
   Directly after the Ftrace formats comes the information about
   the event layout.
 
-  The next 4 bytes is a 32 bit word containing the number of
+  The next 4 bytes are a 32-bit word containing the number of
   event systems that are stored in the file. These are the
   directories in debugfs/tracing/events excluding the \fBftrace\fR
   directory.
@@ -120,9 +120,9 @@ EVENT FORMATS
   For the number of times defined by the previous 4 bytes is the
   following:
 
-  A null terminated string containing the system name.
+  A null-terminated string containing the system name.
 
-  4 bytes containing a 32 bit word containing the number
+  4 bytes containing a 32-bit word containing the number
   of events within the system.
 
   For the number of times defined in the previous 4 bytes is the
@@ -139,7 +139,7 @@ KALLSYMS INFORMATION
   Directly after the event formats comes the information of the mapping
   of function addresses to the function names.
 
-  The next 4 bytes is a 32 bit word containing the size of the
+  The next 4 bytes are a 32-bit word containing the size of the
   data holding the function mappings.
 
   The next set of data is of the size defined by the previous 4 bytes
@@ -155,8 +155,8 @@ TRACE_PRINTK INFORMATION
   This information can be found in:
   debugfs/tracing/printk_formats
 
-  The next 4 bytes is a 32 bit word containing the size of the
-  data holding the printk formats
+  The next 4 bytes are a 32-bit word containing the size of the
+  data holding the printk formats.
 
   The next set of data is of the size defined by the previous 4 bytes
   and contains the information from debugfs/tracing/printk_formats.
@@ -168,11 +168,11 @@ PROCESS INFORMATION
   Directly after the trace_printk formats comes the information mapping
   a PID to a process name.
 
-  The next 8 bytes contains a 64 bit word that holds the size of the
+  The next 8 bytes contain a 64-bit word that holds the size of the
   data mapping the PID to a process name.
 
   The next set of data is of the size defined by the previous 8 bytes
-  and contains the information from debugfs/tracing/saved_cmdlines
+  and contains the information from debugfs/tracing/saved_cmdlines.
 
 
 REST OF TRACE-CMD HEADER
@@ -181,11 +181,11 @@ REST OF TRACE-CMD HEADER
   Directly after the process information comes the last bit of the
   trace.dat file header.
 
-  The next 4 bytes is a 32 bit word defining the number of CPUs that
-  was discovered on the target machine (and has matching trace data
+  The next 4 bytes are a 32-bit word defining the number of CPUs that
+  were discovered on the target machine (and has matching trace data
   for it).
 
-  The next 10 bytes is one of the following:
+  The next 10 bytes are one of the following:
 
     "options  \0"
 
@@ -195,10 +195,10 @@ REST OF TRACE-CMD HEADER
 
   If it is "options  \0" then:
 
-  The next 2 bytes is a 16 bit word defining the current option.
+  The next 2 bytes are a 16-bit word defining the current option.
   If the the value is zero then there are no more options.
 
-  Otherwise, the next 4 bytes contains a 32 bit word containing the
+  Otherwise, the next 4 bytes contain a 32-bit word containing the
   option size. If the reader does not know how to handle the option
   it can simply skip it. Currently there are no options defined,
   but this is here to extend the data.
@@ -206,16 +206,16 @@ REST OF TRACE-CMD HEADER
   The next option will be directly after the previous option, and
   the options ends with a zero in the option type field.
 
-  The next 10 bytes after the options is one of the following:
+  The next 10 bytes after the options are one of the following:
 
   "latency  \0"
 
   "flyrecord\0"
 
-  Which would follow the same as if options were not present.
+  which would follow the same as if options were not present.
 
   If the value is "latency  \0", then the rest of the file is
-  simply ASCII text that was taken from the targets:
+  simply ASCII text that was taken from the target's:
   debugfs/tracing/trace
 
   If the value is "flyrecord\0", the following is present:
@@ -223,10 +223,10 @@ REST OF TRACE-CMD HEADER
   For the number of CPUs that were read earlier, the
   following is present:
 
-  8 bytes that is a 64 bit word containing the offset into the file
+  8 bytes that are a 64-bit word containing the offset into the file
   that holds the data for the CPU.
 
-  8 bytes that is a 64 bit word containing the size of the CPU
+  8 bytes that are a 64-bit word containing the size of the CPU
   data at that offset.
 
 CPU DATA
---
~Randy
